import React from 'react'
import Navbar from 'react-bootstrap/Navbar'
import Nav from 'react-bootstrap/Nav'
import Row from 'react-bootstrap/Row'
import Image from 'react-bootstrap/Image'
import NavLink from 'react-bootstrap/NavLink'

import styles from './styles/Footer.module.scss'
import LogoWithText from '../../../../assets/images/logos/navbar-logo.svg'

const Footer = () => {
    return (
        <Row
            className={`justify-content-between align-items-center py-3 px-3 mx-0 ${styles.footerContainer}`}
        >
            <Navbar  className="d-flex flex-column py-0 w-100">
                <Navbar.Toggle />
                <Navbar.Collapse
                    id="basic-navbar-nav"
                    className={`w-100 flex-column`}
                >
                    <div className={styles.footerLinks} >
                        <Navbar.Brand href="/" className="d-none d-lg-block">
                            <Image
                                src={LogoWithText}
                                rounded
                                className={styles.footerLogo}
                            />
                        </Navbar.Brand>
                        <div className="d-flex flex-column">
                            <p className={'mb-0 ' + styles.footerLink}>
                                COMPANY
                            </p>
                            <a
                                href="/welcome/about_us"
                                className={styles.footerLink}
                            >
                                About us
                            </a>
                            <a
                                href="/welcome/careers"
                                className={styles.footerLink}
                            >
                                Cardinal Talent Careers
                            </a>
                        </div>
                    </div>
                    <div className={`d-flex ${styles.privacyP}`}>
                        <NavLink
                            href="/privacy_policy"
                            className={styles.footerLink}
                        >
                            Privacy policy
                        </NavLink>
                        <span className={styles.footerpip}>|</span>
                        <NavLink
                            href="/terms_of_service"
                            className={styles.footerLink}
                        >
                            Terms of service
                        </NavLink>
                    </div>
                </Navbar.Collapse>
            </Navbar>
        </Row>
    )
}

export default Footer
