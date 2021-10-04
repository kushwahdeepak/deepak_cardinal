class ImportGoogleContactService

  def initialize(contacts, user_id)
    @contacts = contacts
    @user_id = user_id
  end

  def import
    return if @contacts.blank?

    @contacts&.each do |contact|
      email = contact[:email].first[:address] rescue nil

      next if email.blank? || Contact.find_by(email: email, user_id: @user_id).present?

      attr = get_user_attributes(contact)

      if contact[:addresses].present? && (address = contact[:addresses].first).present?
        attr.merge!(get_address_attributes(address))
      end

      if (user = User.find_by(email: email)).present?
        attr.merge!({target_user_id: user.id})
      end

      Contact.create!(attr)
    end
  end

  def get_user_attributes(contact)
    email = contact[:email].first[:address] rescue nil
    phone = contact[:phone].first[:number] rescue nil

    attr = {
      first_name: contact[:first_name],
      last_name: contact[:last_name],
      email: email,
      phone_number: phone,
      job_title: contact[:job_title],
      dob: contact[:dob],
      source: 'gmail',
      user_id: @user_id,
      status: 0
    }
    attr
  end

  def get_address_attributes(address)
    {
      street: address[:street],
      city: address[:city],
      region: address[:region],
      country: address[:country],
      postal_code: address[:postal_code],
      full_address: address[:formatted]
    }
  end

end
