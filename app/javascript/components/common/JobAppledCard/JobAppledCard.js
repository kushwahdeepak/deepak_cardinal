import React, { useEffect } from 'react'
import { Card, Col, Image, Row } from 'react-bootstrap'
import feather from 'feather-icons'
import styles from './styles/JobAppledCard.module.scss'
import CompanyPlaceholderImage from '../../../../assets/images/talent_page_assets/company-placeholder.png'
import {handelBrokenUrl} from '../../common/Utils'
import Moment from 'moment'

const JobAppledCard = (props) => {
    const {
        submission,
        job,
        organization,
        showJobDetails
    } = props

    // todo check if user already applied - waiting for backend support
    const alreadyApplied = false

    useEffect(() => {
        feather.replace()
    })

    const JobAvatarUrl = (logo) => {
      return logo ? logo : CompanyPlaceholderImage
    }

    return (
        <a href={`/jobs/${job?.id}`} className={styles.descriptionLink}>
        <Card
            className={styles.jobCard}
        >
            <Card.Body>
                <Row className="align-items-center">
                    <Col
                        lg={2} md={2} sm={12} xs={12}
                        className={`d-sm-flex align-items-sm-center flex-sm-column flex-lg-row text-center ${styles.cardResponsive}`}
                    >
                        {alreadyApplied && (
                            <i
                                data-feather="check"
                                className={styles.checkIcon}
                            ></i>
                        )}
                        <Image
                            src={
                                JobAvatarUrl(job?.logo)
                            }
                            fluid
                            className={`${styles.cardResponsive} ${styles.jobCardImage, 'companyJobLogo'}`}
                            onError={(e) => {handelBrokenUrl(e)}}
                        />
                    </Col>
                    <Col lg={7} md={7} sm={12} xs={12} className="px-0">
                        <Row>
                            <Col className={styles.jobCardCol}>
                                <p className={styles.jobCardText}>
                                    {organization?.name}
                                </p>
                                <span className={styles.jobCardTitle}>
                                    {job?.name}
                                </span>
                                <p className={styles.jobCardText}>{organization?.city} {organization?.region} {organization?.country}</p>
                            </Col>
                        </Row>
                    </Col>
                    <Col lg={3} md={3} sm={12} xs={12} className="px-0">
                        <Row>
                            <Col className={styles.jobCardCol}>
                                <p className={styles.jobCardText}>
                                    Applied {Moment(submission?.created_at).fromNow()} on {Moment(submission?.created_at).format('l')}
                                </p>
                            </Col>
                        </Row>
                    </Col>
                </Row>
            </Card.Body>
        </Card>
        </a>
    )
}

export default JobAppledCard
