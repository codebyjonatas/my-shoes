class ShoeQuery
  def initialize(params = {})
    @params = params
    @relation = Shoe.all
  end

  def call
    @relation = @relation.by_gender(@params[:gender]) if @params[:gender].present?
    @relation = @relation.in_stock if @params[:in_stock] == "1"
    @relation = @relation.search(@params[:search]) if @params[:search].present?
    @relation
  end
end
