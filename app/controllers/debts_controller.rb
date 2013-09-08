# encoding: utf-8
class DebtsController < ApplicationController
  # GET /debts
  # GET /debts.json
  before_filter :require_login
  before_filter :set_debt, only: [:edit, :update, :show, :destroy, :solve]

  def index
    @debts = Debt.unpaid.where("debtor_id = ?", current_user.id).order("creditor_id")
    @credits = Debt.unpaid.where("creditor_id = ?", current_user.id).order("debtor_id")
    @old_debts = Debt.paid.where("debtor_id = ?", current_user.id).page params[:page]
    @old_credits = Debt.paid.where("creditor_id = ?", current_user.id).page params[:page]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @debts }
    end
  end

  # GET /debts/new
  # GET /debts/new.json
  def new
    @debt = Debt.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @debt }
    end
  end

  # GET /debts/1/edit
  def edit
  end

  # POST /debts
  # POST /debts.json
  def create
    @debt = Debt.new(params[:debt])
    respond_to do |format|
      if @debt.save
        UserMailer.new_debt_email(@debt.debtor.email, @debt.debtor.first_name, @debt.value).deliver unless @debt.debtor_id == current_user.id
        UserMailer.new_credit_email(@debt.creditor.email, @debt.creditor.first_name, @debt.value).deliver unless @debt.creditor_id == current_user.id
        format.html {
          if @debt.debtor_id == current_user.id
            redirect_to debts_path(type:"debt")
            flash[:notice] = 'La dette a bien été créer.'
          else
            redirect_to debts_path(type:"creditor")
            flash[:notice] = 'La créance a bien été créer.'
          end
        }
        format.json { render json: @debt, status: :created, location: @debts }
      else
        format.html { render action: "new" }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /debts/1
  # PUT /debts/1.json
  def update
    respond_to do |format|
      if @debt.update_attributes(params[:debt])
        format.html {
          if @debt.debtor_id == current_user.id
            redirect_to debts_path(type:"debt")
            flash[:notice] = 'La dette a bien été mise à jour.'
          else
            redirect_to debts_path(type:"credit")
            flash[:notice] = 'La créance a bien été mise à jour.'
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debts/1
  # DELETE /debts/1.json
  def destroy
    @debt.destroy

    respond_to do |format|
      format.html {
        if @debt.debtor_id == current_user.id
          redirect_to debts_path(type:"debt")
          flash[:notice] = 'La dette a bien été effacée.'
        else
          redirect_to debts_path(type:"credit")
          flash[:notice] = 'La créance a bien été effacée.'
        end
      }
      format.json { head :no_content }
    end
  end

  # PUT /debts/1
  # PUT /debts/1.json
  def solve
    @debt = Debt.find(params[:id])
    respond_to do |format|
      if @debt.update_attributes(:is_paid=>true)
        format.html {
          UserMailer.warn_debtor_email(@debt.debtor.email, @debt.creditor.first_name, @debt.value, @debt.title).deliver
          if @debt.debtor_id == current_user.id
            redirect_to debts_path(type:"debt")
            flash[:notice] = 'La dette a bien été soldée.'
          else
            redirect_to debts_path(type:"creditor")
            flash[:notice] = 'La créance a bien été soldée.'
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @debt.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_debt
    @debt = Debt.where("debtor_id = #{current_user.id} OR creditor_id = #{current_user.id}").find(params[:id])
  end

  def warn_creditor
    @debt = Debt.find(params[:id])
    respond_to do |format|
      format.html {
        UserMailer.warn_creditor_email(@debt.creditor.email, @debt.debtor.first_name, @debt.value, @debt.title).deliver
        redirect_to debts_path(type:"debt")
        flash[:notice] = 'Le créancier a bien été prévenu'
      }
    end

  end

end
