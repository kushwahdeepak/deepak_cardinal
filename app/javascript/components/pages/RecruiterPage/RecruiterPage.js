import React from 'react'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'

import ImageOne from '../../../../assets/images/recruiter_page_assets/recruiter-landing.png'
import RightArrow from '../../../../assets/images/recruiter_page_assets/arrow-right-long.svg'
import './styles/RecruiterPage.scss'

import {
    H1,
    P,
    Button,
    CONTAINER,
    GRID,
    COL,
    A,
} from './styles/RecruiterPage.styled'

const RecruiterPage = () => {
    return (
        <>
            <section style={{ background: '#F9FAFF' }}>
                <Row className="mx-0 main-find">
                    <Col className="d-flex flex-column flex-wrap align-items-center justify-content-center mb-2">
                        <div className="find-details">
                            <H1 className="find-tittle">
                                Find the Perfect <br /> Candidate Everytime
                            </H1>
                            <P>Using the world’s best free ATS & CRM</P>
                            <Button
                                onClick={() =>
                                    (window.location.href = '/users/sign_in')
                                }
                            >
                                Get Started for Free
                            </Button>
                        </div>
                    </Col>
                    <Col className="pr-0 d-flex justify-content-end">
                        <Image src={ImageOne} className="img-fluid" />
                    </Col>
                </Row>
            </section>

            <section className="check-out" style={{ marginTop: '100px' }}>
                <CONTAINER>
                    <P size={40} height={55} color="#000000">
                        Check out what we have to offer
                    </P>
                    <P marginTop={0}>Here’s an overview of our features</P>
                    <GRID>
                        <Row>
                            <COL className="requeir-details col-sm-6 col-12 col-md-6 col-lg-4">
                                <P color="#1D2447">Refer for Rewards</P>
                                <P
                                    marginTop={10}
                                    weight={300}
                                    size={16}
                                    height={22}
                                    center
                                >
                                    Submit candidates to active job posts and
                                    recieve commissions for hires.
                                </P>
                                <A href="/welcome/refer_for_rewards">
                                    Find out more{' '}
                                    <Image
                                        src={RightArrow}
                                        style={{ marginLeft: '15px' }}
                                    />
                                </A>
                            </COL>
                            <COL className="requeir-details col-sm-6 col-12 col-md-6 col-lg-4"
                                style={{
                                    borderLeft: '1px solid #E4E9FF',
                                    borderRight: '1px solid #E4E9FF',
                                }}
                            >
                                <P color="#1D2447">On-Demand Recruiter</P>
                                <P
                                    marginTop={10}
                                    weight={300}
                                    size={16}
                                    height={22}
                                    center
                                >
                                    Apply to become a top recruiter and get
                                    hired for hourly recruiting jobs.
                                </P>
                                <A href="/welcome/on_demand_recruiter">
                                    Find out more{' '}
                                    <Image
                                        src={RightArrow}
                                        style={{ marginLeft: '15px' }}
                                    />
                                </A>
                            </COL>
                            <COL className="requeir-details col-sm-12 col-12 col-md-12 col-lg-4">
                                <P color="#1D2447">ATS Features</P>
                                <P
                                    marginTop={10}
                                    weight={300}
                                    size={16}
                                    height={22}
                                    center
                                >
                                    Manage job leads, view applicant analytics,
                                    schedule interviews and more all in one
                                    place!
                                </P>
                                <A href="/users/sign_in">
                                    Find out more{' '}
                                    <Image
                                        src={RightArrow}
                                        style={{ marginLeft: '15px' }}
                                    />
                                </A>
                            </COL>
                        </Row>
                        <Row style={{ borderTop: '1px solid #E4E9FF' }}>
                            <COL className="requeir-details col-sm-6 col-12 col-md-6 col-lg-4">
                                <P color="#1D2447">Chrome Extension</P>
                                <P
                                    marginTop={10}
                                    weight={300}
                                    size={16}
                                    height={22}
                                    center
                                >
                                    Get contact info for any profile while
                                    navigating through Linkedin, Github, and
                                    more.
                                </P>
                            </COL>
                            <COL className="requeir-details col-sm-6 col-12 col-md-6 col-lg-4"
                                style={{
                                    borderLeft: '1px solid #E4E9FF',
                                    borderRight: '1px solid #E4E9FF',
                                }}
                            >
                                <P color="#1D2447">Join Organizations </P>
                                <P
                                    marginTop={10}
                                    weight={300}
                                    size={16}
                                    height={22}
                                    center
                                >
                                    Join organizations of companies you’re
                                    recruiting for and easily access shared
                                    candidate data.
                                </P>
                            </COL>
                            <COL className="requeir-details col-sm-12 col-12 col-md-12 col-lg-4">
                                <P color="#1D2447">Email Features</P>
                                <P
                                    marginTop={10}
                                    weight={300}
                                    size={16}
                                    height={22}
                                    center
                                >
                                    Send mass lead sourcing campaigns or
                                    marketing campaigns with our convenient
                                    email sequencing feature.
                                </P>
                            </COL>
                        </Row>
                    </GRID>
                </CONTAINER>
            </section>
        </>
    )
}

export default RecruiterPage
