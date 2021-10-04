import React from 'react'
import styles from './styles/ProfileAvatar.module.scss'
import { Dropdown, Image } from 'react-bootstrap';



const ProfileAvatar = ({profileAvatar, userId, organization_id, isEmployer, currentUser}) => {
  return(
    <Dropdown drop="down">
      <Dropdown.Toggle id="dropdown-basic" className={styles.profileAvatarDropdownButton}>
          <span className={styles.userName}>Welcome  {currentUser.first_name}</span>&nbsp;
          <Image src={profileAvatar} alt="Avatar" className={styles.avatar} />
            
          <Dropdown.Menu align="right">
            <Dropdown.Item href={`/users/profile/${userId}`}>View Profile</Dropdown.Item>
            <Dropdown.Item href="/account/setting">Account Setting</Dropdown.Item>
            {isEmployer && <Dropdown.Item href={`/organizations/${organization_id}/careers`}>Organizations Profile</Dropdown.Item>}
            <Dropdown.Item onClick={()=>localStorage.removeItem("user")} href="/users/sign_out" data-method="delete"> Log Out</Dropdown.Item>
          </Dropdown.Menu>
      </Dropdown.Toggle>
    </Dropdown>
  )
}

export default ProfileAvatar;
