module AccountsHelper

  def step?
    # Określanie obecnego kroku
    case @account.current_step
      when 'first'
        '1'
      when 'second'
        '2'
      when 'last'
        '3'
      end
  end

end

