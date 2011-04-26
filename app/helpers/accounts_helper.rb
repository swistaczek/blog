module AccountsHelper

  def step?
    # Czy premium jest aktywne. Widoczne tylko dla zalogowanego.
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

