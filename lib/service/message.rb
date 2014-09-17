# encoding: utf-8
module Service
  class Message

    def self.send_code_by_phone(phone)
      code = rand_num_code(6)
      Rails.logger.info("Verify Code: phone =>  #{phone} ; code => #{code}")
      content = "欢迎使用股神汇，验证码是:#{code}"
      if Rails.cache.write([:verify_code, phone], code, :expires_in => 15.minutes)
        send_code_channel(content, phone)
      else
        false
      end
    end

    def self.valid_phone_code(phone, code)
      code == Rails.cache.read([:verify_code, phone]) && Rails.cache.delete([:verify_code, phone])
    end

    def self.judge_phone_format(phone)
      rule = /^0?(13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$/
      !!rule.match(phone)
    end

    private
    def self.rand_num_code(num)
      code = ''
      num.times { code << rand(0..9).to_s}
      return code
    end

    def self.send_code_channel(content, phone)
      # response = Unirest.post "http://124.172.250.160/WebService.asmx/mt",
      #   headers:{ "Accept" => "application/x-www-form/urlencoded" }, 
      #   parameters:{
      #     Sn: "SDK-ZQ-CZWL-0736",
      #     Pwd: "Candzen_#10",
      #     mobile: phone,
      #     content: content
      #   }

      # return_code = Hash.from_xml(response.raw_body)

      # case return_code["int"]
      # when "0"
      #   true
      # when "-1"
      #   # 用户名或密码错误
      #   Rails.logger.info("#{Time.now} ========> 短信发送接口调用失败，失败原因：用户名或密码错误")
      #   false
      # when "-2"
      #   # 发送短信余额不足
      #   Rails.logger.info("#{Time.now} ========> 短信发送接口调用失败，失败原因：发送短信余额不足")
      #   false
      # when "-6"
      #   # 参数有误
      #   Rails.logger.info("#{Time.now} ========> 短信发送接口调用失败，失败原因：参数有误")
      #   false
      # when "-7"
      #   # 权限受限
      #   Rails.logger.info("#{Time.now} ========> 短信发送接口调用失败，失败原因：权限受限")
      #   false
      # when "-8"
      #   # Ip失败
      #   Rails.logger.info("#{Time.now} ========> 短信发送接口调用失败，失败原因：Ip失败")
      #   false
      # when "-11"
      #   # 内部数据库错误
      #   Rails.logger.info("#{Time.now} ========> 短信发送接口调用失败，失败原因：内部数据库错误")
      #   false
      # end
      true
    end
  end
end