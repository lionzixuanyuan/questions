class Question < ActiveRecord::Base

  def answer_list
    "<dt>Q:#{question}</dt>
  <dd>
    <ul>
      <li>好想好想去这里游学啊。</li>
    </ul>
    <div class='buttons'>
      <a href='' class='vote'>赞</a>
      <a href='' class='expand'>查看全部(<span>999</span>)</a>
      <a href='' class='reply'>回复</a>
    </div>
  </dd>"
  end
end
