import React, {useEffect, useState} from "react";
import './styles/EmployerOrganization.scss';
import styles from './styles/EmployerOrganization.module.scss';
import Image from 'react-bootstrap/Image';
import { Col, Row } from 'react-bootstrap'
import profileImage from '../../../../assets/images/img_avatar.png'
import Tooltip from "react-bootstrap/Tooltip";
import OverlayTrigger from "react-bootstrap/OverlayTrigger";
import {firstCharacterCapital} from '../../../utils/index'
import { makeRequest } from "../../common/RequestAssist/RequestAssist";

function InvitedMembersList({invitedRecruiters, organization}) {
  const renderTooltip = name => (
    <Tooltip>{name}</Tooltip>
  );

  const handleResendInvitation = async (recruiter_id) =>{
    const url = `/organizations/${organization.id}/invitations`
    const formData = new FormData()
    formData.append('invitation[invited_user_id]', recruiter_id)
    formData.append('organization_id', organization.id)
    const CSRF_Token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute('content')

    try {
        await makeRequest(url,  'post', formData,{
            contentType: 'application/json',
            loadingMessage: 'Submitting...',
            createResponseMessage: (response) => {

              return {message: response.message}
            },
        }).then((res) => {
            setIsOpen(false);
            setRecruiter('')
        })    
    } catch (e) {
        console.error(e.message)
        setErrorFetchingRecruiteer(e.message)
    }
}
    return(
      <>
        {invitedRecruiters?.map((invitedRecruiter) => {
          const recruiter_name = firstCharacterCapital(invitedRecruiter?.first_name) + ' ' + firstCharacterCapital(invitedRecruiter?.last_name)
          return(
              <Col xs={4}>
                <div key={invitedRecruiter?.id} className={`${styles.MemberContainer}`}>
                  <Image
                    src={invitedRecruiter?.image_url ? invitedRecruiter.image_url : profileImage}
                    className={`${styles.MemberProfilePhoto}`}
                  />
                  <div>
                    <OverlayTrigger placement="top" overlay={renderTooltip(recruiter_name)}>
                      <div className={`${styles.MemberName}`}>{invitedRecruiter && recruiter_name }</div>
                    </OverlayTrigger>
                    <div className={`${styles.MemberDesignation}`}>{invitedRecruiter?.role? firstCharacterCapital(invitedRecruiter.role) : ''}</div>
                    <span className={`${styles.MemberInvite}`}> Invited </span>
                    <button className={`${styles.MemberResendInvite}`} onClick={() => {handleResendInvitation(invitedRecruiter.id)}}> Resend Invite
                    </button>
                  </div>
                </div>
              </Col>
          )
        }) || '' }
      </>
    )
}
export default InvitedMembersList;
