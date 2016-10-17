class EmployeeNameValidator < ActiveModel::Validator
  def validate(record)
    # if record.name && record.name.split(" ").count != 3
    #   record.errors[:name] << 'ФИО должно состоять из трех слов'
    # end
    mask =/^[а-яА-Я]+[\s]{1}[а-яА-Я]+[\s]{1}[а-яА-Я]+$/
    if record.name && (record.name =~ mask).nil?
      record.errors[:name] << 'ФИО должно состоять из трех слов на кириллице'
    end
  end
end