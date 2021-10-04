import React, { useEffect, useState } from 'react'
import axios from 'axios'
import { isEmpty, isNil } from 'lodash'
import styles from './styles/RequestAssist.module.scss'
import feather from 'feather-icons'
import BubbleSpinner from '../../../../assets/images/bubble-spinner.svg'
import { Image } from 'react-bootstrap'

const defaultOptions = {
    createSuccessMessage: (response) => response.msg, // we don't show a success message at all by default
    createResponseMessage: (res) => ({
        message: res.msg,
        messageType: res.type,
        loading: false,
    }),
    createErrorMessage: (e) => e.message,
    loadingMessage: 'Submitting...',
    onSuccess: () => {},
    onError: () => {},
    contentType: 'application/json',
}

let setRequestAssistProps

/*
 * We define this hook to allow state sharing between makeRequest(...)
 * and the RequestAssist component. RequestAssist uses the returned raProps
 * as its own props, and makeRequest(...) use the setRAProps function
 * (renamed to setRequestAssistProps) to update the values of those props.
 */
function useRAProps() {
    const [raProps, setRAProps] = useState({})

    setRequestAssistProps = setRAProps

    return raProps
}

async function makeRequest(url, method, payload, options = {}) {
    options = { ...defaultOptions, ...options }

    setRequestAssistProps({
        loading: true,
        loadingMessage: options.loadingMessage,
    })

    const CSRF_Token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute('content')

    try {
        const response = await axios[method.toLowerCase()](url, payload, {
            headers: {
                'content-type': options.contentType,
                'X-CSRF-Token': CSRF_Token,
            },
        })

        const successMessage = options.createSuccessMessage(response)
        const responseMessage = options.createResponseMessage(response.data)
        setRequestAssistProps({ ...responseMessage })

        options.onSuccess(response)

        return response
    } catch (e) {
        const errorMessage = options.createErrorMessage(e)
        setRequestAssistProps({
            message: errorMessage,
            messageType: 'failure',
            loading: false,
            autoClose: true,
        })
        options.onError(e)
        return null
    }
}

function RequestAssist() {
    const [show, setShow] = useState(loading || !isEmpty(message))
    const [timeoutId, setTimeoutId] = useState(-1)

    const raProps = useRAProps()

    const defaultProps = {
        message: '',
        messageType: 'primary',
        messageShowTime: 10000,
        autoClose: true,
        loading: false,
        loadingMessage: defaultOptions.loadingMessage,
    }

    const {
        message,
        messageType,
        messageShowTime,
        autoClose,
        loading,
        loadingMessage,
    } = { ...defaultProps, ...raProps }

    if(messageType === 'failure' ){
        localStorage.setItem('requestFailed', true)
    }

    useEffect(() => {
        setShow(loading || !isEmpty(message))

        clearTimeout(timeoutId)

        if (autoClose && !loading) {
            const id = setTimeout(() => {
                setShow(false)
            }, messageShowTime)

            setTimeoutId(id)
        }
    }, [loading, isEmpty(message)])

    useEffect(() => {
        feather.replace()
    }, [])

    const hasMessage = !isEmpty(message)

    return (
        <div className={styles.raAssist} style={{ opacity: show ? 1 : 0 }}>
            <div
                className={styles.messageContainer}
                style={{ opacity: loading ? 1 : 0 }}
            >
                <Image src={BubbleSpinner} />
                {!isEmpty(loadingMessage) && (
                    <div className={styles.loadingMessage}>
                        {loadingMessage}
                    </div>
                )}
            </div>
            <div
                className={`${styles.messageContainer} ${styles.message} ${styles[messageType]}`}
                style={{ opacity: hasMessage ? 1 : 0 }}
            >
                {!autoClose && (
                    <div className={styles.containerTop}>
                        <div
                            onClick={(e) => {
                                e.preventDefault()
                                e.stopPropagation()
                                setShow(false)
                            }}
                            className={styles.windowIcon}
                        >
                            <i data-feather="x" width="15px" height="15px"></i>
                        </div>
                    </div>
                )}
                <div className={styles.containerBottom}>{message}</div>
            </div>
        </div>
    )
}

export { RequestAssist as default, makeRequest }
