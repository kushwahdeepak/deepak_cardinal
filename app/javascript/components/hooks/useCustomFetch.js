// @flow
import { useState, useEffect, useRef } from 'react'

import axios from 'axios'

function useCustomFetch(url) {
    const [data, setData] = useState(null)
    const [error, setError] = useState(null)
    const [loading, setLoading] = useState(true)
    const [isReload, setIsReload] = useState(true)
    const urlRef = useRef(url)
    async function customFetch(url) {
        axios
            .get(url)
            .then((res) => {
                setData(res.data)
                setLoading(false)
            })
            .catch((err) => {
                setError(err.message)
                setLoading(false)
            })
    }
    function reload() {
        setLoading(true)
        setIsReload(true)
    }

    function updateError(errors) {
        setError(errors)
    }
    useEffect(() => {
        if (isReload || urlRef.current !== url) {
            urlRef.current = url
            reload()
        }
    }, [isReload, url])
    
    useEffect(() => {
        if (isReload) {
            if (url) {
                customFetch(url)
            }
        }
    }, [url, isReload])


    return [data, loading, error, updateError]
}
export default useCustomFetch
