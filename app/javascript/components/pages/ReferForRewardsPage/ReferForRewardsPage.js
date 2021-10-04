import React from 'react'
import styled from 'styled-components'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'

import ImageOne from '../../../../assets/images/refer_for_rewards_assets/image-one.png'
import SubmitQualifiedCandidatesImage from '../../../../assets/images/refer_for_rewards_assets/submit-qualified-candidates.svg'
import BrowseActiveJobPostsImage from '../../../../assets/images/refer_for_rewards_assets/browse-active-job-posts.svg'
import SignUpAsRecruiterImage from '../../../../assets/images/refer_for_rewards_assets/sign-up-as-recruiter.svg'
import CommissionsForHiredCandidates from '../../../../assets/images/refer_for_rewards_assets/commissions-for-hired-candidates.svg'
import './styles/ReferForRewardsPagemodule.scss'


const H1 = styled.h1`
    font-weight: 800;
    font-size: 40px;
    line-height: 68px;
    color: #262b41;
    margin-bottom: ${(props) => props.marginBottom || 0}px;
    margin-top: ${(props) => props.marginTop || 0}px;
`

const P = styled.p`
    font-weight: ${(props) => props.weight || 'normal'};
    font-size: ${(props) => props.size || 22}px;
    line-height: ${(props) => props.height || 30}px;
    color: ${(props) => props.color || '#262b41'};
    margin-bottom: 0px;
    margin-top: ${(props) => props.marginTop || -10}px;
    text-align: ${(props) => (props.center ? 'center' : 'unset')};
`

const Button = styled.button`
    padding: 10px 40px;
    font-weight: 800;
    font-size: 18px;
    line-height: 25px;
    color: #ffffff;
    background: linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%
    );
    border-radius: 50px;
    margin-top: 20px;
    align-self: flex-start;
`

const Circle = styled.div`
    width: 50px;
    height: 50px;
    border-radius: 25px;
    font-style: normal;
    font-weight: 800;
    font-size: 26.6667px;
    line-height: 36px;
    text-align: center;
    display: inline-flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    left: -25px;
    top: -15px;
`

const HowItWorksItem = ({ title, image, text, id, circleStyle = {} }) => {
    return (
        <div
            className="d-flex flex-column how-it-info"
            style={{ maxWidth: '225px', marginBottom: '10px' }}
        >
            <div className="position-relative">
                <Image
                    src={image}
                    style={{ width: '200px', height: '200px' }}
                />
                <Circle style={circleStyle}>{id}</Circle>
            </div>
            <P size={24} height={33} marginTop={30} center>
                {title}
            </P>
            <P weight={300} size={16} height={22} marginTop={10} center>
                {text}
            </P>
        </div>
    )
}

const HOW_IT_WORKS_ITEMS = [
    {
        image: SignUpAsRecruiterImage,
        title: 'Sign up as a recruiter',
        text: 'Create your recruiter account and add your resume to be approved to submit candidates',
        circleStyle: {
            background: '#FFEFF9',
            color: '#FEA6DD',
        },
    },
    {
        image: BrowseActiveJobPostsImage,
        title: 'Browse active job posts',
        text: 'Look through job posts that are accepting candidate submissions and filter for jobs that suit your candidates',
        circleStyle: {
            background: '#F6EAFF',
            color: '#CB89FF',
        },
    },
    {
        image: SubmitQualifiedCandidatesImage,
        title: 'Submit qualified candidates',
        text: 'If a job suits your candidate’s experience well, submit the candidate’s resume along with some basic information',
        circleStyle: {
            background: '#DEF1FF',
            color: '#72C3FE',
        },
    },
    {
        image: CommissionsForHiredCandidates,
        title: 'Earn commissions for hired candidates',
        text: 'Track your candidate’s application progress, and, if they are hired, you will receive reward associated with the position',
        circleStyle: {
            background: '#DEE1FF',
            color: '#8691FA',
        },
    },
]

const ReferForRewardsPage = () => {
    return (
        <>
            <section style={{ background: '#F9FAFF' }}>
                <Row className="make-main">
                    <Col className="d-flex flex-column flex-wrap align-items-center justify-content-center ">
                        <div className="make-details">
                            <H1>Make up to $50,000 per hire</H1>
                            <P>
                                By inviting your network or uploading candidate
                                referrals
                            </P>
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
                        <Image src={ImageOne} className="img-fluid " />
                    </Col>
                </Row>
            </section>

            <section
                className="d-flex flex-column align-items-center how-it-details"
                style={{ paddingBottom: '185px' }}
            >
                <H1 marginTop={87} marginBottom={56}>
                    How it works
                </H1>
                <div className="d-flex flex-wrap justify-content-around w-100">
                    {HOW_IT_WORKS_ITEMS.map((item, idx) => (
                        <HowItWorksItem
                            key={item.title}
                            image={item.image}
                            title={item.title}
                            text={item.text}
                            id={idx + 1}
                            circleStyle={item.circleStyle}
                        />
                    ))}
                </div>
            </section>

            <section
                style={{
                    background:
                        'linear-gradient(105.72deg, #E9EFFF -6.67%, #E8EAFF 52.25%, #E2E1FF 103.38%)',
                    display: 'flex',
                    flexDirection: 'column',
                    justifyContent: 'center',
                    alignItems: 'center',
                    minHeight: '250px',
                }}
            >
                <P size={30} height={41} color="#1D2447">
                    Check out our other recruiter features!
                </P>
                <Button
                    onClick={() => (window.location.href = '/users/sign_in')}
                    style={{ alignSelf: 'center' }}
                >
                    For Recruiters
                </Button>
            </section>
        </>
    )
}

export default ReferForRewardsPage
