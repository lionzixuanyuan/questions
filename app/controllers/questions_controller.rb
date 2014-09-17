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

  # 发送验证短信
  def send_valid_sms
    if params[:phone].present? && Service::Message.send_code_by_phone(params[:phone])
      result = {:state => "success"}
    else
      result = {:state => "error"}
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

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render action: 'show', status: :created, location: @question }
      else
        format.html { render action: 'new' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
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
