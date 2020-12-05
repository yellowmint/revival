import React, {useContext, useEffect} from "react"
import styles from "./shop.module.scss"
import {TKind, Unit} from "./unit"
import {MoveContext} from "./moveContext"

interface ShopProps {
    shop: TShop
}

export type TShop = {
    goods: Array<TGood>
}

export type TGood = {
    kind: TKind
    level: number
    count: number
    price: number
}

export const Shop = ({shop}: ShopProps) => {
    const [ctx, dispatch] = useContext(MoveContext)

    useEffect(() => {
        dispatch({type: "updateShop", payload: shop})
    }, [shop])

    return (<section className={styles.shop}>
            <div className={styles.wrapper}>
                {shop.goods.map(good => (
                    <div key={`${good.kind}-${good.level}`}
                         onClick={() => dispatch({type: "selectGood", payload: good})}
                    >
                        <ShopUnit good={good} selected={ctx.selectedGood === good}/>
                    </div>
                ))}
            </div>
        </section>
    )
}

interface TShopUnitProps {
    good: TGood
    selected: boolean
}

export const ShopUnit = ({good, selected}: TShopUnitProps) => (
    <div className={`${styles.shopUnit} ${selected && styles.selected}`}>
        <Unit kind={good.kind} level={good.level}/>
        <div className="swell-around">
            <span className={styles.countBadge}>{good.count}</span>
            <span className={styles.moneyBadge}>{good.price}</span>
        </div>
    </div>
)
