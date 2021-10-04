import React, { useState } from 'react'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Alert from 'react-bootstrap/Alert'
import styles from './styles/CandidateSearchPage.module.scss'
import CandidateManager from '../../common/CandidateManager/CandidateManager'

function CandidateSearchPage({ currentUser, isEmailConfigured, jobs, currentOrganization, memberOrganization }) {
    const [errorSubmitting, setErrorSubmitting] = useState(null)

    return (
        <Container className="p-0" fluid>
             <label
                className={styles.mainTitle + ' page-title'}
                style={{ marginBottom: '2rem' }}
            >
                <span>Candidate Search</span><br/>
                <span className={styles.subTitle}>Browse thousands of active and passive candidates</span>
            </label>
            
            <Container className={styles.newcontiner + ' p-5'} fluid>
                {errorSubmitting && (
                    <Alert
                        variant="danger"
                        onClose={() => setErrorSubmitting(null)}
                        dismissible
                    >
                        {errorSubmitting}
                    </Alert>
                )}

                <Row>
                    <Col md="12" className="">
                        <CandidateManager
                            tableColumns={[
                                'candidate_search'
                            ]}
                            isEmailConfigured={isEmailConfigured}
                            user={currentUser}
                            candidateSource="candidate_search"
                            jobId={null}
                            title=""
                            showSearchField={true}
                            memberOrganization={memberOrganization}
                            enableStages={false}
                            jobs = {jobs}
                            candidatePage={true}
                            placeholder='Search...'
                            currentOrganization={currentOrganization}
                        />
                    </Col>
                </Row>
            </Container>
        </Container>
    )
}

export default CandidateSearchPage
