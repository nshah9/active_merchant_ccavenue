module OffsitePayments #:nodoc:
    module Integrations #:nodoc:
        module Ccavenue
            class Helper < OffsitePayments::Helper
                mapping :amount, 'Amount'
                mapping :order, 'Order_Id'
                mapping :billing_address, :name  => 'billing_cust_name',
                  :email      => 'billing_cust_email',
                  :phone      => 'billing_cust_tel',
                  :address    => 'billing_cust_address',
                  :city       => 'billing_cust_city',
                  :state      => 'billing_cust_state',
                  :country    => 'billing_cust_country',
                  :zip        => 'billing_zip_code',
                  :notes      => 'billing_cust_notes'

                mapping :delivery_address, :name  => 'delivery_cust_name',
                        :phone      => 'delivery_cust_tel',
                        :address    => 'delivery_cust_address',
                        :city       => 'delivery_cust_city',
                        :state      => 'delivery_cust_state',
                        :country    => 'delivery_cust_country',
                        :zip        => 'delivery_zip_code'

                def redirect(mapping = {})
                    add_field 'Redirect_Url', mapping[:return_url]
                    add_field 'Merchant_Id', OffsitePayments::Integrations::Ccavenue.merchant_id
                    add_field 'Checksum', get_checksum(
                        OffsitePayments::Integrations::Ccavenue.merchant_id,
                        self.fields[self.mappings[:order]],
                        self.fields[self.mappings[:amount]],
                        mapping[:return_url],
                        OffsitePayments::Integrations::Ccavenue.work_key
                    )
                end

                private

                def get_checksum(*args)
                    require 'zlib'
                    Zlib.adler32 args.join('|'), 1
                end
            end
        end
    end
end
