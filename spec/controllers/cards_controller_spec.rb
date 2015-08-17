require "rails_helper"

describe Dashboard::CardsController do
  describe "parsing_html" do
    before do
      @user = create(:user)
      @block = create(:block, user: @user)
      @controller.send(:auto_login, @user)
    end

    it "add delayed job" do
      post :parsing_html, { format: "js",
                            parsing_html:
                              { block_id: @block.id,
                                url: "http://www.learnathome.ru/blog/100-beautiful-words",
                                origin_selector: "table tbody tr td[2] p",
                                translated_selector: "table tbody tr td[1] p" }}
      expect(Delayed::Job.count).to eq(1)
      expect(flash[:notice]).to eq("Задача на парсинг сайта успешно поставлена в очередь.")
      expect(flash[:alert]).to eq(nil)
    end

    it "incorrect url" do
      post :parsing_html, { format: "js",
                            parsing_html:
                              { block_id: @block.id,
                                url: "http://www.learnathome.ru/blog/100-beautiful",
                                origin_selector: "table tbody tr td[2] p",
                                translated_selector: "table tbody tr td[1] p" }}
      expect(Delayed::Job.count).to eq(0)
      expect(flash[:alert]).to eq("Проверьте правильность введенных данных.")
      expect(flash[:notice]).to eq(nil)
    end

    it "incorrect css original" do
      post :parsing_html, { format: "js",
                            parsing_html:
                              { block_id: @block.id,
                                url: "http://www.learnathome.ru/blog/100-beautiful-words",
                                origin_selector: "table tbody",
                                translated_selector: "table tbody tr td[1] p" }}
      expect(Delayed::Job.count).to eq(0)
      expect(flash[:alert]).to eq("Проверьте правильность введенных данных.")
      expect(flash[:notice]).to eq(nil)
    end

    it "incorrect css translated" do
      post :parsing_html, { format: "js",
                            parsing_html:
                              { block_id: @block.id,
                                url: "http://www.learnathome.ru/blog/100-beautiful-words",
                                origin_selector: "table tbody tr td[2] p",
                                translated_selector: "table tbody" }}
      expect(Delayed::Job.count).to eq(0)
      expect(flash[:alert]).to eq("Проверьте правильность введенных данных.")
      expect(flash[:notice]).to eq(nil)
    end

    it "empty block field" do
      post :parsing_html, { format: "js",
                            parsing_html:
                              { url: "http://www.learnathome.ru/blog/100-beautiful-words",
                                origin_selector: "table tbody tr td[2] p",
                                translated_selector: "table tbody" }}
      expect(Delayed::Job.count).to eq(0)
      expect(flash[:alert]).to eq("Проверьте правильность введенных данных.")
      expect(flash[:notice]).to eq(nil)
    end

    it "create cards from html" do
      Delayed::Worker.delay_jobs = false
      post :parsing_html, { format: "js",
                            parsing_html:
                              { block_id: @block.id,
                                url: "http://www.learnathome.ru/blog/100-beautiful-words",
                                origin_selector: "table tbody tr td[2] p",
                                translated_selector: "table tbody tr td[1] p" }}
      expect(Delayed::Job.count).to eq(0)
      expect(flash[:notice]).to eq("Задача на парсинг сайта успешно поставлена в очередь.")
      expect(flash[:alert]).to eq(nil)
      expect(Card.exists?(original_text: "вода")).to eq(true)
      expect(Card.exists?(translated_text: "aqua")).to eq(true)
    end
  end
end
