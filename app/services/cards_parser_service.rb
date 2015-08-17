class CardsParserService
  class << self
    def schedule_parsing(user_id, params)
      block_id = params[:block_id]
      return false unless block_id && user_id

      html = Nokogiri::HTML(open(params[:url]))
      original = html.css(params[:origin_selector]).map(&:content)
      translated = html.css(params[:translated_selector]).map(&:content)

      return false unless original.size == translated.size && original.any?
      return false if original[0] == translated[0]

      Card.delay.create_from_html(user_id, block_id, original, translated)
      true

    rescue Exception
      return false
    end

    def create_cards_from_html(user_id, block_id, original, translated)
      original.each_with_index do |original_text, index|
        translated_text = translated[index]
        Card.create(user_id: user_id, block_id: block_id,
                    original_text: original_text,
                    translated_text: translated_text)
      end
    end
  end
end
