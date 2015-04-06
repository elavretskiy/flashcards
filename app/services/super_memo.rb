class SuperMemo
  def algorithm(interval, repeat, efactor, quality)
    if quality >= 3
      efactor = set_efactor(efactor, quality)
      set_interval(interval, repeat + 1, efactor)
    else
      set_interval(interval, 1, efactor)
    end
  end

  private

  def set_interval(interval, repeat, efactor)
    interval = case repeat
               when 1 then 1
               when 2 then 6
               else (interval * efactor).round
               end
    { interval: interval, efactor: efactor, repeat: repeat }
  end

  def set_efactor(efactor, quality)
    efactor = (efactor < 1.3 ? 1.3 : efactor)
    efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
  end
end