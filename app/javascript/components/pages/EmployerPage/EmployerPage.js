import React, { useState, useEffect, useRef } from 'react'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import feather from 'feather-icons'

import styles from './styles/EmployerPage.module.scss'
import ImageOne from '../../../../assets/images/recruiter_page_assets/employer-landing-page-1.png'
import VenmoLogoImage from '../../../../assets/images/recruiter_page_assets/venmo-logo.png'
import CarouselImageOne from '../../../../assets/images/recruiter_page_assets/carousel-1.png'
import CarouselImageTwo from '../../../../assets/images/recruiter_page_assets/carousel-2.png'
import CarouselImageThree from '../../../../assets/images/recruiter_page_assets/carousel-3.png'
import CandidateTwoImage from '../../../../assets/images/recruiter_page_assets/AdobeStock2.png'

import './styles/CustomCarousel.scss'

const CustomCarousel = ({ customWidth = 1300, children }) => {
    const [imageIndex, setImageIndex] = useState(1)
    const [translateX, setTranslateX] = useState(0)

    useEffect(() => {
        feather.replace()
    })

    const nextSlide = (event) => {
        if (event.target.id === 'previous') {
            if (imageIndex !== 1) {
                setImageIndex((prev) => prev - 1)
                setTranslateX((prev) => prev + customWidth)
            } else {
                setImageIndex(children.length)
                setTranslateX((children.length - 1) * customWidth * -1)
            }
        } else {
            if (imageIndex !== children.length) {
                setImageIndex((prev) => prev + 1)
                setTranslateX((prev) => prev - customWidth)
            } else {
                setImageIndex(1)
                setTranslateX(0)
            }
        }
    }

    return (
        <div className="carousel_container">
            <button
                className="carousel__button previous"
                id="previous"
                onClick={nextSlide}
            >
                <i data-feather="chevron-left"></i>
            </button>
            <button
                className="carousel__button next"
                id="next"
                onClick={nextSlide}
            >
                <i data-feather="chevron-right"></i>
            </button>
            <div
                style={{
                    background: '#f4f7ff',
                    borderRadius: '50px',
                    paddingBottom: '40px',
                }}
            >
                <div className="carousel">
                    <div
                        className="carousel__images"
                        style={{ transform: `translateX(${translateX}px)` }}
                    >
                        {children}
                    </div>
                </div>
                <div
                    style={{
                        textAlign: 'center',
                        marginTop: '40px',
                    }}
                >
                    {Array.from(Array(children.length)).map((x, idx) => (
                        <span
                            key={idx}
                            className={`dot ${
                                imageIndex - 1 == idx ? 'active' : ''
                            }`}
                            onClick={() => {
                                setImageIndex(idx + 1)
                                setTranslateX(idx * customWidth * -1)
                            }}
                        ></span>
                    ))}
                </div>
            </div>
        </div>
    )
}

const EmployerPage = () => {
    return (
        <div className={styles.employerPage}>
            <section className={styles.getStartedSection}>
                <Row className={styles.newRow}>
                    <Col className={styles.getStartedColumn}>
                        <div style={{ maxWidth: '500px' }}>
                            <h1 className={styles.title}>
                                The world’s best free AI enabled ATS
                            </h1>
                            <p className={styles.subtitle}>
                                Leverage our database of thousands of top
                                passive candidates
                            </p>
                            <Button
                                className={styles.getStartedButton}
                                href="/users/sign_in?page=/welcome/employer"
                            >
                                Get Started for Free
                            </Button>
                        </div>
                    </Col>
                    <Col md="6" className="px-0">
                        <Image src={ImageOne} className="img-fluid w-100"  />
                    </Col>
                </Row>
            </section>

            <section className={styles.experiencesSection}>
                <Image src={VenmoLogoImage} />
                <p className={styles.experienceText}>
                    "We are thrilled with the iOS engineer that we hired from
                    CardinalTalent!{' '}
                    <b>The CardinalTalent candidate pipeline is excellent</b>{' '}
                    and we look forward to hiring more candidates from you
                    soon!”
                </p>
                <p className={styles.experienceName}>Gaurav Kumar</p>
                <p className={styles.experienceRole}>Engineering Manager</p>
            </section>

            <section className="d-none">
                <CustomCarousel>
                    <div className="mySlides">
                        <Row className="title">
                            Utilize our AI for sourcing or full-cycle recruiting
                        </Row>
                        <Row>
                            <Col className="d-flex flex-column justify-content-center align-items-start">
                                <h2 className="subtitle">
                                    Upload jobs for free
                                </h2>
                                <p className="text">
                                    Efficient job importing through our bulk job
                                    import process. Import hundred of jobs in
                                    one click!
                                </p>
                            </Col>
                            <Col md="auto">
                                <Image
                                    src={CarouselImageOne}
                                    className="d-block w-100"
                                />
                            </Col>
                        </Row>
                    </div>

                    <div className="mySlides">
                        <Row className="title">
                            Utilize our AI for sourcing or full-cycle recruiting
                        </Row>
                        <Row>
                            <Col className="d-flex flex-column justify-content-center align-items-start">
                                <h2 className="subtitle">
                                    Schedule Interviews
                                </h2>
                                <p className="text">
                                    Track all your interviews and add feedback
                                    from interviews for easy applicant tracking.
                                </p>
                            </Col>
                            <Col md="auto">
                                <Image
                                    src={CarouselImageTwo}
                                    className="d-block w-100"
                                />
                            </Col>
                        </Row>
                    </div>

                    <div className="mySlides">
                        <Row className="title">
                            Utilize our AI for sourcing or full-cycle recruiting
                        </Row>
                        <Row>
                            <Col className="d-flex flex-column justify-content-center align-items-start">
                                <h2 className="subtitle">
                                    Easy Applicant Tracking
                                </h2>
                                <p className="text">
                                    View analytics to track metrics, engagement,
                                    and applicants for jobs all in one place.
                                </p>
                            </Col>
                            <Col md="auto">
                                <Image
                                    src={CarouselImageThree}
                                    className="d-block w-100"
                                />
                            </Col>
                        </Row>
                    </div>
                </CustomCarousel>
            </section>
            <div class="container">
                <div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
                    <div className="main-slider">
                    <ol class="carousel-indicators">
                        <li data-target="#carouselExampleControls" data-slide-to="0" className="dot active"></li>
                        <li data-target="#carouselExampleControls" data-slide-to="1" className="dot"></li>
                        <li data-target="#carouselExampleControls" data-slide-to="2" className="dot"></li>
                      </ol>
                  <div class="carousel-inner">
                    <div class="carousel-item active">
                    <Row className="title">
                            Utilize our AI for sourcing or full-cycle recruiting
                        </Row>
                    <div className="row">
                        <div className="col-md-6">
                        <div className="slider-details">
                            <div className="slider-info">
                                <h2 className="subtitle">
                                    Upload jobs for free
                                </h2>
                                <p className="text">
                                    Efficient job importing through our bulk job
                                    import process. Import hundred of jobs in
                                    one click!
                                </p>
                            </div>
                        </div>
                            
                        </div>
                        <div className="col-md-6">
                            <Image
                                src={CarouselImageOne}
                                className="img-fluid"
                            />
                        </div>
                    </div>
                     
                    </div>
                    <div class="carousel-item">
                    <Row className="title">
                                Utilize our AI for sourcing or full-cycle recruiting
                            </Row>
                    <div className="row">
                        <div className="col-md-6">
                        <div className="slider-details">
                            <div className="slider-info">
                                <h2 class="subtitle">Schedule Interviews</h2>
                                <p class="text">Track all your interviews and add feedback from interviews for easy applicant tracking.</p>
                            </div>
                        </div>
                            
                        </div>
                        <div className="col-md-6">
                            <Image
                                src={CarouselImageOne}
                                className=" img-fluid"
                            />
                        </div>
                    </div>
                    </div>
                    <div class="carousel-item">
                    <Row className="title">
                                Utilize our AI for sourcing or full-cycle recruiting
                            </Row>
                    <div className="row">
                        <div className="col-md-6">
                        <div className="slider-details">
                            <div className="slider-info">
                                <h2 className="subtitle">
                                    Upload jobs for free
                                </h2>
                                <h2 class="subtitle">Easy Applicant Tracking</h2>
                                <p class="text">View analytics to track metrics, engagement, and applicants for jobs all in one place.</p>
                            </div>
                        </div>
                            
                        </div>
                        <div className="col-md-6">
                            <Image
                                src={CarouselImageOne}
                                className="img-fluid"
                            />
                        </div>
                    </div>
                     
                    </div>
                  </div>
                  <a class="carousel-control-prev carousel__button" href="#carouselExampleControls" role="button" data-slide="prev">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevron-left"><polyline points="15 18 9 12 15 6"></polyline></svg>
                  </a>
                  <a class="carousel-control-next carousel__button" href="#carouselExampleControls" role="button" data-slide="next">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevron-right"><polyline points="9 18 15 12 9 6"></polyline></svg>
                  </a>
                  </div>
                </div>
            </div>
            <section id="importJobsSection">
                <Row
                    className={
                        styles.importJobsImageRow + ' justify-content-center'
                    }
                >
                    <Col xs="auto">
                        <Image
                            src={CandidateTwoImage}
                            fluid
                            roundedCircle
                            className={styles.importJobsImage}
                        />
                    </Col>
                    <Col 
                        xs="auto" className={styles.newRow}
                        className={`d-flex flex-column justify-content-center align-items-start ${styles.aiDetails}`}
                        style={{ marginLeft: '34px', maxWidth: '545px' }}
                    >
                        <p className={styles.title}>
                            AI Recruiting Solutions for your hiring needs
                        </p>
                        <p className={styles.importJobsText}>
                            Post your jobs for free to gain access to our ATS
                            and candidate database.
                        </p>
                        <Button
                            className={styles.importJobsButton}
                            href="/users/sign_in?page=/jobs/new"
                        >
                            Import Jobs Now
                        </Button>
                    </Col>
                </Row>
            </section>
        </div>
    )
}

export default EmployerPage
