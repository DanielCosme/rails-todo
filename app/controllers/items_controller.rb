class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy flip ]

  # GET /items or /items.json
  def index
    @not_done = Item.where(status: false).reverse
    @done = Item.where(status: true).limit(20).reverse
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("items-not-done", partial: "items/item", locals: { item: @item }),
            turbo_stream.replace("new-item-form", partial: "items/form", locals: { item: Item.new }),
          ]
        end
      else
        redirect_to items_path, notice: "Item was not created", status: :see_other
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    if @item.update(item_params)
      redirect_to @item, notice: "Item was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy!
    redirect_to items_path, notice: "TODO was successfully destroyed.", status: :see_other
  end

  def flip
    @item.status = !@item.status

    respond_to do |format|
      if @item.save
        format.turbo_stream do
          target = @item.status ? "items-done" : "items-not-done"
          render turbo_stream: [
            turbo_stream.remove(@item),
            turbo_stream.prepend(target, partial: "items/item", locals: { item: @item })
          ]
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.expect(item: [ :title, :project_id ]).tap do |p|
        p[:project_id] = 1 if p[:project_id].blank?
      end
    end
end
