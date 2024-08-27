import logging

from fastapi import APIRouter, Body

from expense_ai.connections.ai_v2 import extract_expense_items
from expense_ai.connections.db import Database

expenses_router = APIRouter(prefix="/expenses")

logger = logging.getLogger(__name__)

db = Database()


@expenses_router.post("/itemize", tags=["expenses"])
async def get_expenses(image_str: str = Body(embed=True)):
    # return {
    #     'items': [
    #         {
    #             'title': 'Covriel Davarez Lel 1.000 BUC X 12.99 PFAND 12.99 B 1.000 BUC X 8.99 8.99 B 1.000 buc x 0.50 0.50 D 1.000 BUC x 8.49 8.99 B 1.000 buc x 0.50 D500 1.000 BUC X 12.99 12.99 B 1.000 BUC x 9.75 9.75 A 1.000 BUC X 8.69 8.69 A 1.000 BUC x 14.29 14.29 A 1.000 BUC X 8.00 8.09 B 1.150 KG X 6.99 8.04 B 1.000 BUC X 9.89 9.89 B 1.000 BUC X 1,99 13.99 B 1.000 BUC 13.99 13.99 B 1.000 BUC X 5.50 5.59 B 1.000 BUC X 9.99% 7 9.99 B 1.000 BUC X 4.39 4.39 B 1.000 BUC X 2.49 2.49 A 1.000 BUC X 2.49 19 A 1.000 BUC x 2.49 24A 1.000 BU 49 1.000 BUL 2.49 2.49 A 1.000 BUC 2.4) 2.49 A 1.000 BUC X 249 2.49 A 1.000 BUC X 2.49 2.49 K'},
    #         {'title': 'Suc portocute fara pulpa'}, {'title': 'Garantie 1 buc'}, {'title': 'Suc portocale fага рура'}, {'title': 'Garantie 1 buc.'},
    #         {'title': 'Somon afumat'}, {'title': 'Kinder Prajitura Pingui'}, {'title': 'Desert cu cocOS'}, {'title': 'Batoane de ciocolata'}, {'title': 'Unt 65%'},
    #         {'title': 'Banane'}, {'title': 'Cheddar Felli SK4'}, {'title': 'Parmezan ras/fasi'}, {'title': 'Reducere Lidl Plus DISCOUNT'},
    #         {'title': 'Parmezan ras/ fast'}, {'title': 'Reducere Lidl Plus DISCOUNT'}, {'title': 'Chifle pentru hamburger'}, {'title': 'Biscuiti cu bezea si banan'},
    #         {'title': 'Tortilla Wraps'}, {'title': '7 Days Spumant'}, {'title': '7 Days Spumant'}, {'title': '7 Days Spumant'}, {'title': '7 Days Cocoa'},
    #         {'title': '7 Days Cocoa'}, {'title': '7 Days Cocoa'}, {'title': '7 Days Cocoa'}, {'title': '7 Days Cocoa'}],
    #     'total': 163.58
    # }
    r = extract_expense_items(image_str)
    print(r)
    return r;
