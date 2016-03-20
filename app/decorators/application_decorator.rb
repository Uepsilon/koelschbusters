class ApplicationDecorator < Draper::Decorator
  include Draper::CanCan

  def self.collection_decorator_class
    PaginationDecorator
  end
end
