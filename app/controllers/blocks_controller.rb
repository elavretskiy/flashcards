class BlocksController < ApplicationController
  before_action :set_block, only: [:destroy, :edit, :update, :set_as_current,
                                   :reset_as_current]
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
      current_user.change_current_block(@block.id, params[:set_as_current])
      redirect_to blocks_path
    else
      respond_with @block
    end
  end

  def update
    if @block.update(block_params)
      current_user.change_current_block(@block.id, params[:set_as_current])
      redirect_to blocks_path
    else
      respond_with @block
    end
  end

  def destroy
    @block.destroy
    respond_with @block
  end

  def set_as_current
    current_user.change_current_block(@block.id, true)
    redirect_to blocks_path
  end

  def reset_as_current
    current_user.change_current_block(@block.id, false)
    redirect_to blocks_path
  end

  private

  def set_block
    @block = current_user.blocks.find(params[:id])
  end

  def block_params
    params.require(:block).permit(:title)
  end
end
