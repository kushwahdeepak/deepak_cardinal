import React, { useState, useEffect, useRef } from 'react'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import feather from 'feather-icons'
import styles from './styles/EmailVerificationPage.module.scss'
import success from '../../../../assets/images/icons/thumbs-up.png'

const Success = () => {
    return (
        <div className={styles.errorPage}>
            <section className={styles.getStartedSection}>
                <Row>
                    <Col md="12" lg="12" className={styles.getStartedColumn}>
                        <div>
                            <div className="img-block">
                                <img
                                    src={success}
                                    alt=""
                                    className="reset-screen-img"
                                />
                            </div>
                            <h1 className={styles.title}>
                                Email verification successfully
                            </h1>
                            <p className={styles.subtitle}>
                                Your email is successfully verified now.
                            </p>
                            <p className={styles.subtitle}>
                                Now you can use email sequencing and candidate upload feature.
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
export default Success
