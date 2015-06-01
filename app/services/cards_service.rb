class CardsService
  class << self
    def parsing_html(user_id, block_id, url, css_original, css_translated)
      parse = false

      if block_id && user_id
        begin
          html = Nokogiri::HTML(open(url))
        rescue Exception
          return false
        end

        original_texts = html.css(css_original)
        translated_texts = html.css(css_translated)

        if original_texts.size == translated_texts.size && original_texts.size != 0
          if original_texts[0] != translated_texts[0]
            Card.delay.create_delayed_job(user_id, block_id, url,
                                          css_original, css_translated)

            parse = true
          end
        end
      end

      parse
    end

    def create_cards(user_id, block_id, original_texts, translated_texts)
      original_texts.each_with_index do |original, index|
        original_text = original.content.downcase
        translated_text = translated_texts[index].content.downcase
        card = Card.new(user_id: user_id, block_id: block_id,
                        original_text: original_text,
                        translated_text: translated_text)
        card.save
      end
    end
  end
end
