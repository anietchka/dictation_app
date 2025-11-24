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

    if @dictation.valid?
      generation_result = generate_dictation_content

      if generation_result[:success]
        @dictation.content = generation_result[:content]
        if @dictation.save
          redirect_to @dictation, notice: t("dictations.create_success")
        else
          render :new, status: :unprocessable_entity
        end
      else
        @dictation.errors.add(:base, generation_result[:error])
        render :new, status: :unprocessable_entity
      end
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
    params.require(:dictation).permit(:name, :level, :min_words, :max_words, :min_sentences, :max_sentences, :requested_words, :requested_rules)
  end

  def generate_dictation_content
    Dictations::Generate.new(@dictation).call
  rescue StandardError => e
    Rails.logger.error("Error generating dictation content: #{e.message}")
    { success: false, error: t("dictations.generate_error", error: e.message) }
  end
end
