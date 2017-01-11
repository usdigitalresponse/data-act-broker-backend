from functools import wraps
from flask import g

from dataactcore.interfaces.db import GlobalDB
from dataactcore.models.domainModels import CGAC, SubTierAgency
from dataactcore.utils.jsonResponse import JsonResponse
from dataactcore.utils.statusCode import StatusCode


# Add the file submission route
def add_domain_routes(app):
    """ Create routes related to domain values for flask app """

    @app.route("/v1/list_agencies/", methods=["GET"])
    @get_cgacs
    def list_agencies(cgacs):
        """ List all CGAC Agencies """
        agency_list = [
            {'agency_name': cgac.agency_name, 'cgac_code': cgac.cgac_code}
            for cgac in cgacs
        ]
        return JsonResponse.create(StatusCode.OK,
                                   {'cgac_agency_list': agency_list})

    @app.route("/v1/list_sub_tier_agencies/", methods=["GET"])
    @get_cgacs
    def list_sub_tier_agencies(cgacs):
        """ List all Sub-Tier Agencies """
        sess = GlobalDB.db().session

        cgac_ids = [cgac.cgac_id for cgac in cgacs]
        sub_tier_agencies = []
        for cgac_id in cgac_ids:
            # agencies = sess.query(SubTierAgency).filter_by(cgac_id=cgac_id)
            sub_tier_agencies.extend(sess.query(SubTierAgency).filter_by(cgac_id=cgac_id))

        sub_tier_agency_list = [
            {   'agency_name': '{}: {}'.format(sub_tier_agency.cgac.agency_name, sub_tier_agency.sub_tier_agency_name),
                'agency_code': sub_tier_agency.sub_tier_agency_code
            } for sub_tier_agency in sub_tier_agencies
        ]
        return JsonResponse.create(StatusCode.OK,
                                   {'sub_tier_agency_list': sub_tier_agency_list})

def get_cgacs(fn):
    """Decorator which provides a list of all CGAC Agencies. The function 
    should have a cgacs parameter as its first argument.""" 
    @wraps(fn)
    def wrapped(*args, **kwargs):
        sess = GlobalDB.db().session
        if g.user is None:
            cgacs = []
        elif g.user.website_admin:
            cgacs = sess.query(CGAC).all()
        else:
            cgacs = [affil.cgac for affil in g.user.affiliations]
        return fn(cgacs, *args, **kwargs)
    return wrapped
