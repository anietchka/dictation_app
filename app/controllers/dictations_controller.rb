class DictationsController < ApplicationController
  before_action :set_dictation, only: [ :show ]

  def index
    @dictations = Dictation.for_user(current_user).order(created_at: :desc)
  end

  def new
    @dictation = Dictation.new
  end

  def show
  end

  def create
    @dictation = current_user.dictations.build(dictation_params)

    if @dictation.save
      redirect_to @dictation, notice: t("dictations.create_success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_dictation
    @dictation = Dictation.for_user(current_user).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to dictations_path, alert: t("dictations.not_found")
  end

  def dictation_params
    params.require(:dictation).permit(:level, :min_words, :max_words, :requested_words, :requested_rules)
  end
end
