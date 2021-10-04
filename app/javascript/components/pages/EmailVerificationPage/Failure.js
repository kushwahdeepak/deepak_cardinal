import React, { useState, useEffect, useRef } from 'react'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import feather from 'feather-icons'
import styles from './styles/EmailVerificationPage.module.scss'
import failed from '../../../../assets/images/icons/thumbs-down.png'

const Failure = () => {
    return (
        <div className={styles.errorPage}>
            <section className={styles.getStartedSection}>
                <Row>
                    <Col md="12" lg="12" className={styles.getStartedColumn}>
                        <div>
                             <div className="img-block">
                                <img
                                    src={failed}
                                    alt=""
                                    className="reset-screen-img"
                                />
                            </div>
                            <h1 className={styles.title}>
                                Email verification Failed
                            </h1>
                            <p className={styles.subtitle}>
                                Your email is not successfully verified Please try again later.
                            </p>
                            <p className={styles.subtitle}>
                                If problem persists then please contact us as <span className={styles.highlight}>support@cardinatalent.ai</span>
                            </p>
                            <Button
                                className={styles.getStartedButton}
                                href="/"
                            >
                                GO TO HOME PAGE
                            </Button>
                        </div>
                    </Col>
                   
                </Row>
            </section>
        </div>    
    )
}
export default Failure
