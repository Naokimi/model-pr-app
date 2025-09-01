class Avo::Resources::UserLesson < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :clock_out_time, as: :date_time
    field :student_id, as: :number
    field :lesson_id, as: :number
    field :student, as: :belongs_to
    field :lesson, as: :belongs_to
  end
end
