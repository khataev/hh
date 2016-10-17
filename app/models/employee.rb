class Employee < ActiveRecord::Base
  include ActiveModel::Validations

  has_and_belongs_to_many :abilities

  validates :name, presence: true
  validates :contacts, presence: true
  validates :salary, presence: true
  validates :abilities, presence: true
  validates :search_status, presence: true

  validates_with EmployeeNameValidator

  # Метод 1 - точное совпадение 1-2-3 = 1-2-3
  def vacancies_complete_match_m1
    Vacancy.find_by_sql [
        "
        SELECT *
          FROM vacancies v
          JOIN (
              SELECT av.vacancy_id, count(*)
              FROM abilities_employees ae
              INNER JOIN abilities_vacancies av ON av.ability_id = ae.ability_id
              WHERE ae.employee_id = :employee_id
              GROUP BY av.vacancy_id
              HAVING (
                  count(*) = (SELECT count(*) FROM abilities_employees WHERE employee_id = :employee_id) AND
                  count(*) = (SELECT count(*) FROM abilities_vacancies avi WHERE avi.vacancy_id = av.vacancy_id)
              )
            ) r ON r.vacancy_id = v.id
         WHERE v.valid_till > :valid_till AND
               v.salary >= :salary
         ORDER BY v.salary DESC
        ",
        { employee_id: id, valid_till: DateTime.now, salary: salary }
    ]
  end

  # Метод 2 - частичное совпадение - любые пересечения множеств, главное, чтобы было общее подмнодество умений
  def vacancies_partial_match_m1
    Vacancy.find_by_sql [
        "
        SELECT *
          FROM vacancies v
          JOIN (
              SELECT av.vacancy_id, count(*)
              FROM abilities_employees ae
              INNER JOIN abilities_vacancies av ON av.ability_id = ae.ability_id
              WHERE ae.employee_id = :employee_id
              GROUP BY av.vacancy_id
              HAVING (
                  count(*) != (SELECT count(*) FROM abilities_employees WHERE employee_id = :employee_id) OR
                  count(*) != (SELECT count(*) FROM abilities_vacancies avi WHERE avi.vacancy_id = av.vacancy_id)
              )
            ) r ON r.vacancy_id = v.id
          WHERE v.valid_till > :valid_till AND
                v.salary > :salary
          ORDER BY v.salary DESC
        ",
        { employee_id: id, valid_till: DateTime.now, salary: salary }
    ]
  end

  # Метод 2 - полное совпадение - умения работника ШИРЕ или равны умениям в вакансии (включает результат Метода 1, а так же 1-2-3 = 1-2 | 1 | 2)
  def vacancies_complete_match_m2
    Vacancy.find_by_sql [
        "
        SELECT DISTINCT v.*
          FROM abilities_employees ae
          INNER JOIN abilities_vacancies av ON av.ability_id = ae.ability_id
          INNER JOIN vacancies v on v.id = av.vacancy_id
          WHERE ae.employee_id = :employee_id AND
            NOT EXISTS (SELECT 1 FROM abilities_vacancies avi
                      WHERE avi.vacancy_id = av.vacancy_id
                        AND avi.ability_id NOT IN (SELECT ability_id FROM abilities_employees WHERE employee_id = :employee_id)
                              ) AND
            v.valid_till > :valid_till AND
            v.salary > :salary
         ORDER BY v.salary DESC
        ",
        { employee_id: id, valid_till: DateTime.now, salary: salary }
    ]
  end

  # Метод 2 - частичное совпадение - любые пересечения подмножеств, главное, чтобы были отличающиеся умения
  def vacancies_partial_match_m2
    Vacancy.find_by_sql [
        "
        SELECT DISTINCT v.*
          FROM abilities_employees ae
          INNER JOIN abilities_vacancies av ON av.ability_id = ae.ability_id
          INNER JOIN vacancies v on v.id = av.vacancy_id
          WHERE ae.employee_id = :employee_id AND
                EXISTS (SELECT 1 FROM abilities_vacancies avi
                      WHERE avi.vacancy_id = av.vacancy_id
                        AND avi.ability_id NOT IN (SELECT ability_id FROM abilities_employees WHERE employee_id = :employee_id)
                              ) AND
            v.valid_till > :valid_till AND
            v.salary > :salary
         ORDER BY v.salary DESC
        ",
        { employee_id: id, valid_till: DateTime.now, salary: salary }
    ]
  end
end
