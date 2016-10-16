class Vacancy < ActiveRecord::Base
  has_and_belongs_to_many :abilities

  validates :name, presence: true
  validates :contacts, presence: true
  validates :salary, presence: true
  validates :abilities, presence: true
  validates :valid_till, presence: true


  def employees_complete_match
    Vacancy.find_by_sql [
        "
        SELECT *
          FROM employees e
          JOIN (
              SELECT ae.employee_id, count(*)
              FROM abilities_vacancies av
              INNER JOIN abilities_employees ae ON av.ability_id = ae.ability_id
              WHERE av.vacancy_id = :vacancy_id
              GROUP BY ae.employee_id
              -- HAVING count(*) = (SELECT count(*) FROM abilities_vacancies WHERE vacancy_id = :vacancy_id)
              HAVING (
                  count(*) = (SELECT count(*) FROM abilities_vacancies WHERE vacancy_id = :vacancy_id) AND
                  count(*) = (SELECT count(*) FROM abilities_employees aei WHERE aei.employee_id = ae.employee_id)
              )
            ) r ON r.employee_id = e.id
         WHERE e.search_status = 1 AND
               e.salary <= :salary
         ORDER BY e.salary ASC
        ",
        { vacancy_id: id, salary: salary }
    ]
  end

  def employees_partial_match
    Vacancy.find_by_sql [
        "
        SELECT *
          FROM employees e
          JOIN (
              SELECT ae.employee_id, count(*)
              FROM abilities_vacancies av
              INNER JOIN abilities_employees ae ON av.ability_id = ae.ability_id
              WHERE av.vacancy_id = :vacancy_id
              GROUP BY ae.employee_id
              -- HAVING count(*) < (SELECT count(*) FROM abilities_vacancies WHERE vacancy_id = :vacancy_id)
              HAVING (
                  count(*) != (SELECT count(*) FROM abilities_vacancies WHERE vacancy_id = :vacancy_id) OR
                  count(*) != (SELECT count(*) FROM abilities_employees aei WHERE aei.employee_id = ae.employee_id)
              )
            ) r ON r.employee_id = e.id
         WHERE e.search_status = 1 AND
               e.salary <= :salary
         ORDER BY e.salary ASC
        ",
        { vacancy_id: id, salary: salary }
    ]
  end
end
