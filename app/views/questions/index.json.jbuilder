json.array!(@questions) do |question|
  json.extract! question, :id, :name, :address, :college, :e_mail, :phone, :question
  json.url question_url(question, format: :json)
end
