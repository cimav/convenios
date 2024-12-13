class AgreementType < ApplicationRecord

  has_many :agreements

  validates :name, presence: true

end
