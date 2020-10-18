class InvoicesController < ApplicationController

	def index
	end

	def new
	end

	def create
		invoice = @current_user.build_invoice
		if params[:invoice].present?
			invoice.invoice_number = params[:invoice][:invoice_number]
			invoice.amount = params[:invoice][:amount]
		end
		if invoice.save
			redirect_to invoices_path
		else
			render_error(400, invoice.errors.full_messages.join(','))
		end
	end

	def edit
	end

	def update
		invoice = @current_user.try(:invoice)
		if params[:invoice].present?
			invoice.invoice_number = params[:invoice][:invoice_number].present? ? params[:invoice][:invoice_number] : invoice.invoice_number
			invoice.amount = params[:invoice][:amount].present? ? params[:invoice][:amount] : invoice.try(:amount)
		end
		if invoice.save
			redirect_to invoices_path
		else
			render_error(400, invoice.errors.full_messages.join(','))
		end
	end

	def destroy
	end

	private

	def invoice_params
		params.permit(:amount, :invoice_number)
	end





end
