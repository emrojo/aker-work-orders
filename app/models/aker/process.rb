class Aker::Process < ApplicationRecord
  has_many :product_processes, foreign_key: :aker_process_id, class_name: "Aker::ProductProcess"
  has_many :products, through: :product_processes
end