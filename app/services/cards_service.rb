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

        original_texts = html.css(css_original).map{ |original| original.content}
        translated_texts = html.css(css_translated).map{ |translated| translated.content}

        if original_texts.size == translated_texts.size && original_texts.size != 0
          if original_texts[0] != translated_texts[0]
            Card.delay.create_delayed_job(user_id, block_id,
                                          original_texts, translated_texts)

            parse = true
          end
        end
      end

      parse
    end

    def create_cards(user_id, block_id, original_texts, translated_texts)
      original_texts.each_with_index do |original_text, index|
        translated_text = translated_texts[index]
        card = Card.new(user_id: user_id, block_id: block_id,
                        original_text: original_text,
                        translated_text: translated_text)
        card.save
      end
    end
  end
end
