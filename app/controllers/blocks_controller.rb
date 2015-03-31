class BlocksController < ApplicationController
  before_action :set_block, only: [:destroy, :edit, :update]
  respond_to :html

  def index
    @blocks = current_user.blocks.all.order('title')
  end

  def new
    @block = Block.new
  end

  def edit
  end

  def create
    @block = current_user.blocks.build(block_params)
    if @block.save
      current_user.set_current_block(@block.id, params[:current_block])
      redirect_to blocks_path
    else
      respond_with @block
    end
  end

  def update
    if @block.update(block_params)
      current_user.set_current_block(@block.id, params[:current_block])
      redirect_to blocks_path
    else
      respond_with @block
    end
  end

  def destroy
    @block.destroy
    respond_with @block
  end

  private

  def set_block
    @block = current_user.blocks.find(params[:id])
  end

  def block_params
    params.require(:block).permit(:title)
  end
end
