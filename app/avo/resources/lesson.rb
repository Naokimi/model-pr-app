class Avo::Resources::Lesson < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :start_time, as: :date_time
    field :subject, as: :text
    field :content, as: :textarea
    field :teacher_id, as: :number
    field :teacher, as: :belongs_to
  end
end
