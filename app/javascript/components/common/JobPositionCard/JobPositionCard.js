import React, { useEffect } from 'react'
import { Card, Col, Image, Row } from 'react-bootstrap'
import feather from 'feather-icons'
import styles from './styles/JobPositionCard.module.scss'
import MatchScoreIcon from '../../../../assets/images/talent_page_assets/match-score-circle.svg'
import CompanyPlaceholderImage from '../../../../assets/images/talent_page_assets/company-placeholder.png'
import MatchScore from '../MatchScore/MatchScore'
import CandidateSkills from '../CandidateSkills/CandidateSkills'
import {handelBrokenUrl} from '../../common/Utils'

const JobPositionCard = (props) => {
    const {
        job,
        matchScore,
        showSkills = true,
        showSalary = true,
        showMatchScore = true,
    } = props

    const {
        id,
        name: jobTitle,
        portalcompanyname: companyName,
        compensation: salary,
        portalcity: location,
        skills,
    } = job

    // todo check if user already applied - waiting for backend support
    const alreadyApplied = false

    useEffect(() => {
        feather.replace()
    })

    const JobAvatarUrl = (logo) => {
      return logo ? logo : CompanyPlaceholderImage
    }

    return (
    <a href={`jobs/${id}`} className={styles.descriptionLink}>
        <Card
            className={styles.jobCard}
            style={{
                backgroundColor: `${alreadyApplied ? '#F7F7F7' : '#fff'}`,
                cursor: 'pointer',
            }}
        >
            <Card.Body>
                <Row className="align-items-center">
                    <Col
                        lg={3} md={3} sm={12} xs={12}
                        className="d-sm-flex align-items-sm-center flex-sm-column flex-lg-row text-center"
                        style={{ margin: 'auto', width: '100px',height:'auto' }}
                    >
                        {alreadyApplied && (
                            <i
                                data-feather="check"
                                className={styles.checkIcon}
                            ></i>
                        )}
                        <Image
                            src={
                                JobAvatarUrl(job.logo)
                            }
                            fluid
                            className={styles.jobCardImage, 'companyJobLogo'}
                            style={{ margin: 'auto', width: '100px',height:'auto' }}
                            onError={(e) => {handelBrokenUrl(e)}}
                        />
                    </Col>
                    <Col lg={6} md={5} sm={12} xs={12} className="px-0">
                        <Row>
                            <Col className={styles.jobCardCol}>
                                <p className={styles.jobCardText}>
                                    {companyName}
                                </p>
                                <span className={styles.jobCardTitle}>
                                    {jobTitle}
                                </span>
                                <p className={styles.jobCardText}>{location}</p>
                            </Col>
                        </Row>
                        <Row>
                            <Col>
                                {showSkills && (
                                    <Row>
                                        <Col>
                                            <CandidateSkills skills = {skills} />
                                        </Col>
                                    </Row>
                                )}
                            </Col>
                        </Row>

                        {showSalary && (
                            <Row>
                                <Col xs="auto">
                                    <p className={styles.jobCardText}>
                                        Salary:
                                    </p>
                                </Col>
                                <Col className="pl-0">
                                    <p className={styles.jobCardText}>
                                        {salary}
                                    </p>
                                </Col>
                            </Row>
                        )}
                    </Col>
                    {showMatchScore && (
                        <Col
                            lg={3} md={4} sm={12} xs={12}
                            className="d-flex align-items-center justify-content-end"
                        >
                            <MatchScore score={matchScore} big={true} />
                        </Col>
                    )}
                </Row>
            </Card.Body>
        </Card>
    </a>
    )
}

export default JobPositionCard
