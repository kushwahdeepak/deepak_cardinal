import React, {useState} from "react";
import './styles/EmployerOrganization.scss';
import styles from './styles/EmployerOrganization.module.scss';
import Image from 'react-bootstrap/Image';
import { Col, Row } from 'react-bootstrap'
import profileImage from '../../../../assets/images/img_avatar.png'
import Tooltip from "react-bootstrap/Tooltip";
import OverlayTrigger from "react-bootstrap/OverlayTrigger";
import {firstCharacterCapital} from '../../../utils/index'

function MembersList({members}) {
  const [memberName, setMemberName] = useState('');
  const renderTooltip = name => (
    <Tooltip>{name}</Tooltip>
  );

    return(
      <>
        {members?.map((member) => {
          const member_name = firstCharacterCapital(member.first_name) + ' ' + firstCharacterCapital(member.last_name)
          return(
              <Col xs={4}>
                <div key={member.id} className={`${styles.MemberContainer}`}>
                  <Image
                    src={member.image_url ? member.image_url : profileImage}
                    className={`${styles.MemberProfilePhoto}`}
                  />
                  <div>
                    <OverlayTrigger placement="top" overlay={renderTooltip(member_name)}>
                      <div className={`${styles.MemberName}`}>{member && member_name }</div>
                    </OverlayTrigger>
                    <div className={`${styles.MemberDesignation}`}>{member.role? firstCharacterCapital(member.role) : ''}</div>
                    <span  className={`${styles.MemberContact}`}> Contact </span>
                    <span  className={`${styles.MemberActivity}`}> Activity </span>
                  </div>
                </div>
              </Col>
          )
        }) || '' }
      </>
    )
}
export default MembersList;
