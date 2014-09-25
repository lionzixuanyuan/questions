class Question < ActiveRecord::Base
  validates_uniqueness_of :phone, :message => "每个手机号只能提交一个问题。"

  has_many :answers

  def answer_list
    "<dt class='close'>
      <i class='arrow'></i>
      <span class='q-title'><i class='photo-icons photo#{rand(1..10)}'></i>#{question}</span>
      <span class='buttons'>
        <span>#{address}  #{college}</span>
        <a href='' class='vote' q-id='#{id}'>(<span>#{awesome_count}</span>)</a>
        <a href='' class='reply'>(<span>#{answers.count}</span>)</a>
      </span>
    </dt>
    <dd class='hide'>
      <ul id='ul_#{id}'>
        #{answers.collect{|a| '<li>'+a.answer+'</li>'}.join}
      </ul>
      <p class='reply-form'>
        <textarea name='' id='answer_#{id}' cols='30' rows='10'></textarea>
        <button class='answer' q-id='#{id}'>回复</button>
      </p>
    </dd>"
  end
end
