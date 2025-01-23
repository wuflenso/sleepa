class Sleep < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :duration_seconds, presence: true
  validates :start, presence: true
  validates :end, presence: true, comparison: { greater_than: :start }

  class << self
    def paginated(relation, limit, offset)
      total = relation.count
      items = relation
      items = relation.offset(offset).limit(limit) if offset && limit
      [ items, total ]
    end

    def get_sleeps(user_id)
      self.where(user_id: user_id).where(deleted_at: nil)&.order(start: "desc")
    end

    def bulk_get_last_week_sleep_records(user_ids)
      beginning_of_last_week = (DateTime.now.in_time_zone - 7.days).beginning_of_week
      sleeps = self.where(user_id: user_ids)&.where(deleted_at: nil)&.where(start: beginning_of_last_week..beginning_of_last_week.end_of_week)&.order(duration_seconds: "desc")
      return [] if sleeps.nil?
      sleeps
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
    self.start = Time.zone.parse(params[:start]) unless params[:start].nil?
    self.end = Time.zone.parse(params[:end]) unless params[:end].nil?
    self.duration_seconds = self.end - self.start
    self.save!
    self
  end

  def delete
    self.deleted_at = Time.current
    self.save!
    self
  end
end
