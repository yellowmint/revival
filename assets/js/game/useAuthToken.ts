import {useEffect, useState} from "react"

export const useAuthToken = () => {
    const [authToken, setAuthToken] = useState<string | null>(null)

    useEffect(() => {
        const tokenTag = document.querySelector('meta[name="auth-token"]') as HTMLMetaElement

        if (tokenTag) {
            setAuthToken(tokenTag.content)
        }
    }, [])

    return {authToken}
}
