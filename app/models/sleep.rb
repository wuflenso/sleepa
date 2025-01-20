class Sleep < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :duration_seconds, presence: true
  validates :end, comparison: { greater_than: :start }

  class << self
    def get_sleeps(user_id)
      self.where(user_id: user_id).where(deleted_at: nil)&.order(start: "desc")
    end

    def clock_in(params)
      record = self.new(params)
      record.end = Time.current if record.end.nil?
      record.duration_seconds = (record.end - record.start).to_int
      record.save!
      record
    end
  end

  def update(params)
    self.start = params[:start]
    self.end = params[:end]
    self.duration_seconds = params[:end] - params[:start]
    self.save!
    self
  end

  def delete
    self.deleted_at = Time.current
    self.save!
    self
  end
end
