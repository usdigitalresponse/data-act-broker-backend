from dataactbroker.decorators import get_fabs_sub_tier_agencies, requires_login
from dataactbroker.handlers.agency_handler import get_accessible_agencies, get_all_agencies, organize_sub_tier_agencies

from dataactcore.utils.jsonResponse import JsonResponse
from dataactcore.utils.statusCode import StatusCode


# Add the file submission route
def add_domain_routes(app):
    """ Create routes related to domain values for flask app """

    @app.route("/v1/list_agencies/", methods=["GET"])
    @requires_login
    def list_agencies():
        """ Get all agencies the current user has DABS access to. """
        return JsonResponse.create(StatusCode.OK, get_accessible_agencies())

    @app.route("/v1/list_all_agencies/", methods=["GET"])
    def list_all_agencies():
        """ List all CGAC and FREC Agencies """
        return JsonResponse.create(StatusCode.OK, get_all_agencies())

    @app.route("/v1/list_sub_tier_agencies/", methods=["GET"])
    @get_fabs_sub_tier_agencies
    def list_sub_tier_agencies(sub_tier_agencies):
        """ List all Sub-Tier Agencies user has FABS permissions for
            Args:
            sub_tier_agencies - List of all SubTierAgencies generated by the get_fabs_sub_tier_agencies decorator,
                required to list only sub_tier_agencies that user has FABS permissions for
        """
        return JsonResponse.create(StatusCode.OK, organize_sub_tier_agencies(sub_tier_agencies))
