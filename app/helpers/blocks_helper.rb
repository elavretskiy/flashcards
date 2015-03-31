module BlocksHelper
  def current_block_check_box(block)
    if @block.id == current_user.current_block
      check_box_tag :current_block, nil, true
    else
      check_box_tag :current_block, nil, false
    end
  end
end
