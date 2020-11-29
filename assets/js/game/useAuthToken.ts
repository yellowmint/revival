import {useEffect, useState} from "react"

export const useAuthToken = () => {
    const [authToken, setAuthToken] = useState<string | null>()

    useEffect(() => {
        const tokenTag = document.querySelector('meta[name="auth-token"]') as HTMLMetaElement
        tokenTag ? setAuthToken(tokenTag.content) : setAuthToken(null)
    }, [])

    return {authToken}
}
