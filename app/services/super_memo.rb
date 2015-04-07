# Algorithm SM-2 used in the computer-based variant of the SuperMemo method and
# involving the calculation of easiness factors for particular items:
# http://www.supermemo.com/english/ol/sm2.htm

class SuperMemo
  def algorithm(interval, repeat, efactor, quality)
    efactor = set_efactor(efactor, quality)
    if quality >= 3
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
    efactor = efactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    efactor < 1.3 ? 1.3 : efactor
  end
end