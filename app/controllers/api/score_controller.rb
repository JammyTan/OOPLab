class Api::ScoreController < ApplicationController

    def create
        retrieve_admin
        permitted = params.permit({ project_score: [:project_id, :point, :no]})
        projects = permitted[:project_score].as_json
        if @teaching_assistant.nil?
            raise '此為admin帳號，請登入助教帳號再送出分數'
        end
        projects.each do |project|
            score = Score.find_by(project_id: project["project_id"].to_i,
                                  teaching_assistant_id: @teaching_assistant.id,
                                  no: project["no"].to_i)
            if score
                score.point = project["point"].to_i
                score.save!
            else
                Score.create!(project_id: project["project_id"].to_i,
                              teaching_assistant_id: @teaching_assistant.id,
                              point: project["point"].to_i.to_i,
                              no: project["no"].to_i)
            end
        end

        render HttpStatusCode.ok
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def all
        retrieve_admin
        permitted = params.permit(:project_id, :no)
        scores = Score.where(project_id: permitted[:project_id].to_i,
                             no: permitted[:no].to_i)
        # Log.info(scores[0].teaching_assistant.to_json)
        render HttpStatusCode.ok(scores.as_json(
            include: {
                teaching_assistant: {
                    only: [:id, :name]
                }
            }, only: [:point, :no, :id]
        ))
    rescue => e
        Log.exception(e)
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    def destroy
        retrieve_admin
        permitted = params.permit(:score_id)
        score = Score.find_by(id: permitted[:score_id])
        score.destroy!
        render HttpStatusCode.ok
    rescue => e
        render HttpStatusCode.forbidden(
            {
                errorMsg: "#{$!}"
            }
        )
    end

    private

    def retrieve_admin
        require_headers
        if @access_token.present?
            @teaching_assistant = TeachingAssistant.find_by(access_token: @access_token)
            @admin = Admin.find_by(access_token: @access_token)
        end
        if @teaching_assistant.nil? and @admin.nil?
            raise '憑證失效'
        end
    end

    def require_headers
        @access_token = request.headers["AUTHORIZATION"]
    end
end
