class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  require "service/message"

  # 首页
  def city_index
    @title = "首页"
  end

  # 留言
  def message
    @questions_count = Question.all.group(:city).count
    @title = "留言"
  end

  # 介绍
  def introduce
    @title = "介绍"
  end

  # 获取城市问题列表
  def city_messages
    questions = Question.where(:city => params[:city]).collect{|q| q.answer_list}

    result = {
      title: params[:city],
      q_html: questions.join
    }
    render :json => result.to_json
  end

  # 发送验证短信
  def send_valid_sms
    if params[:phone].present? && !Question.exists?(:phone => params[:phone]) && Service::Message.send_code_by_phone(params[:phone])
      result = {:state => "success"}
    else
      result = {:state => "error"}
      result = result.merge({:msg => "每个手机号只能提交一个问题～"}) if Question.exists?(:phone => params[:phone])
    end
    render :json => result.to_json
  end

  # 校验验证短信
  def examine_valid_num
    if Service::Message.valid_phone_code(params[:phone], params[:valid_num])
      result = {:state => "success"}
    else
      result = {:state => "error"}
    end
    
    render :json => result.to_json
  end

  # 点赞
  def click_awesome
    question = Question.find params[:question_id]
    question.update_attribute("awesome_count", question.awesome_count + 1)
    render :text => "success"
  end

  # 回答问题
  def answer_question
    question = Question.find params[:question_id]
    Answer.create(:question => question, :answer => params[:answer_text])
    render :text => "success"
  end

  # Excel 导出
  require 'csv'
  def export_excel
    questions = Question.all

    report = StringIO.new
    report = CSV.generate do |title|
       title << ['name', 'address', 'college', 'e_mail', 'phone', 'question', 'created_at', 'city', 'awesome_count']
       questions.each do |c|
          title << [ c.name,  c.address,  c.college,  c.e_mail,  c.phone,  c.question,  c.created_at,  c.city,  c.awesome_count ]
       end
       count_str = ""
       questions.group(:city).count.each_pair{|k, v| count_str += "[#{k}]:#{v};"}
       title << ["total num:#{questions.length}", count_str]
    end

    send_data report, :filename => "result.xls", :type =>  "application/vnd.ms-excel"
  end

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @title = "首页"
    @question = Question.new
    @question.city = params[:city]
    render :layout => "form"
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    redirect_to message_questions_path if @question.save

    # respond_to do |format|
    #   if @question.save
    #     format.html { redirect_to @question, notice: 'Question was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @question }
    #   else
    #     format.html { render action: 'new', city: params[:city], layout: "form" }
    #     format.json { render json: @question.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:name, :address, :college, :e_mail, :phone, :question, :city)
    end
end
