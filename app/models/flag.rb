class Flag < ActiveRecord::Base
	belongs_to :polygon
	attr_accessible :flag_value, :is_primary, :polygon_id, :session_id, :flag_type
	validates :flag_value, presence: true
	validates :polygon_id, presence: true
	validates :flag_type, presence: true

	def self.flags_for_session(session_id)
		Flag.where(:session_id => session_id).count
	end

	def self.progress_for_session(session_id)
		Flag.select("DISTINCT polygons.geometry, flags.*").joins(:polygon).where(:session_id => session_id)
	end
end
